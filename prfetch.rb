#!/usr/bin/env ruby

begin
  require 'octokit'
rescue LoadError
  puts "The 'octokit' gem is not installed. Install it by running: gem install octokit"
  exit 1
end

require 'uri'
require 'fileutils'

# Custom error class for missing or invalid GH_OWNER_REPO environment variable
class InvalidOwnerRepoError < StandardError
  def initialize(msg="Error: Set the GH_OWNER_REPO environment variable in the format 'owner/repo'")
    super
  end
end

def create_octokit_client
  Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
end

def prepare_directory(repo, owner, pr_number, author_username)
  folder_name = "#{repo}_#{owner}_#{author_username}_#{pr_number}"
  FileUtils.mkdir_p(folder_name)
  folder_name
end

def write_patch_to_file(folder_name, pr_number, patch_content)
  File.write("#{folder_name}/pr-#{pr_number}.patch", patch_content)
end

def download_pr_patch(input)
  client = create_octokit_client

  if input =~ /^\d+$/ # If input is just a numeric ID
    default_owner_repo = ENV['GH_OWNER_REPO']
    raise InvalidOwnerRepoError unless default_owner_repo&.include?('/')

    owner, repo = default_owner_repo.split('/')
    pr_number = input
  else
    # If a full URL is provided
    uri = URI.parse(input)
    path_parts = uri.path.split('/')
    repo, owner, pr_number = path_parts[-3], path_parts[-4], path_parts[-1]
  end

  pr_data = client.pull_request(owner + '/' + repo, pr_number)
  author_username = pr_data[:user][:login]

  folder_name = prepare_directory(repo, owner, pr_number, author_username)
  patch_content = client.pull_request(owner + '/' + repo, pr_number, accept: 'application/vnd.github.VERSION.patch')

  write_patch_to_file(folder_name, pr_number, patch_content)
end

if ARGV.length != 1
  puts "Usage: #{$PROGRAM_NAME} [Pull Request URL or ID]"
  puts "Note: Set the GH_OWNER_REPO environment variable in the format 'owner/repo' when using a PR ID."
  puts "      Ensure the GITHUB_ACCESS_TOKEN environment variable is set with your GitHub access token."
  puts "      You can view your GitHub token by running 'gh auth token'."
  exit 1
end

begin
  download_pr_patch(ARGV[0])
rescue InvalidOwnerRepoError => e
  puts e.message
  exit 1
rescue Octokit::NotFound
  puts "Pull Request not found or access token is invalid. Ensure the GITHUB_ACCESS_TOKEN is correctly set."
  puts "You can view your GitHub token by running 'gh auth token'."
  exit 1
end
