#!/usr/bin/env ruby
# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2026, Jared W. Cook
# SPDX-License-Identifier: AGPL-3.0-or-later

require "pathname"
require "yaml"

ROOT = Pathname.new(__dir__).join("..").realpath

REQUIRED_FILES = %w[
  .github/dependabot.yml
  .github/workflows/community-files.yml
  CODEOWNERS
  CODE_OF_CONDUCT.md
  FUNDING.yml
  ISSUE_TEMPLATE/01-bug-report.yml
  ISSUE_TEMPLATE/02-feature-request.yml
  ISSUE_TEMPLATE/config.yml
  LICENSE.md
  README.md
  SECURITY.md
  compose.yml
  docker/Dockerfile
  profile/README.md
].freeze

EXPECTED_PROFILE_VALUES = [
  "Jared W. Cook",
  "https://github.com/jcook3701",
  "https://github.com/cookscodeinc",
  "https://cookscodeinc.github.io/",
  "cookscodeinc+github@gmail.com"
].freeze

FORBIDDEN_BRANDING = [
  "Copyright (c) 2025-2026, Jared Cook",
  "github.com/cookscodeinc/.github"
].freeze

errors = []

REQUIRED_FILES.each do |relative_path|
  errors << "missing required file: #{relative_path}" unless ROOT.join(relative_path).file?
end

yaml_paths = Dir.glob(
  [".github/**/*.{yml,yaml}", "ISSUE_TEMPLATE/**/*.{yml,yaml}", "FUNDING.{yml,yaml}", "compose.{yml,yaml}"],
  base: ROOT.to_s
).sort

yaml_paths.each do |relative_path|
  parsed = YAML.safe_load(ROOT.join(relative_path).read, aliases: false)
  errors << "YAML document must be a mapping: #{relative_path}" unless parsed.is_a?(Hash)
rescue Psych::Exception => e
  errors << "invalid YAML in #{relative_path}: #{e.message.lines.first.strip}"
end

dependabot_path = ROOT.join(".github/dependabot.yml")
if dependabot_path.file?
  dependabot = YAML.safe_load(dependabot_path.read, aliases: false)
  ecosystems = Array(dependabot&.fetch("updates", nil)).filter_map { |entry| entry["package-ecosystem"] }
  %w[docker github-actions].each do |ecosystem|
    errors << "Dependabot does not monitor #{ecosystem}" unless ecosystems.include?(ecosystem)
  end
end

markdown_paths = Dir.glob("**/*.md", base: ROOT.to_s).sort
markdown_paths.each do |relative_path|
  path = ROOT.join(relative_path)
  content = path.read

  content.each_line.with_index(1) do |line, line_number|
    errors << "trailing whitespace: #{relative_path}:#{line_number}" if line.match?(/[ \t]+(?:\r?\n)?\z/)
  end

  content.scan(/\[[^\]]+\]\(([^)]+)\)/).flatten.each do |target|
    next if target.match?(%r{\A(?:https?://|mailto:|#|\?)})

    local_target = target.split(/[?#]/, 2).first
    next if local_target.nil? || local_target.empty?

    resolved = path.dirname.join(local_target).cleanpath
    errors << "broken local link in #{relative_path}: #{target}" unless resolved.exist?
  end
end

profile_path = ROOT.join("profile/README.md")
if profile_path.file?
  profile = profile_path.read
  EXPECTED_PROFILE_VALUES.each do |value|
    errors << "personal profile is missing: #{value}" unless profile.include?(value)
  end
end

repository_text = Dir.glob(
  ["**/*.{md,yaml,yml}", "CODEOWNERS", "Makefile", "docker/Dockerfile"],
  base: ROOT.to_s
)
  .select { |path| ROOT.join(path).file? }
  .map { |path| ROOT.join(path).read }
  .join("\n")

FORBIDDEN_BRANDING.each do |value|
  errors << "outdated or copied branding remains: #{value}" if repository_text.include?(value)
end

unless errors.empty?
  warn errors.map { |error| "ERROR: #{error}" }.join("\n")
  exit 1
end

puts "Validated #{yaml_paths.length} YAML files and #{markdown_paths.length} Markdown files."
