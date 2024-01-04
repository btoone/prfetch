# PRFetch

PRFetch is a Ruby script that automates the process of downloading pull requests from GitHub as patch files. It uses the GitHub API via the Octokit gem to fetch the data and saves the patch file in a specially named directory.

## Features

- Downloads a pull request as a patch file from GitHub.
- Creates a directory named after the project, the PR author's username, and the PR number (e.g., `admin_johndoe_22070`).
- Accepts both a URL or a numeric ID for a pull request.
- Uses environment variables for configuration.

## Requirements

- Ruby
- [Octokit.rb](https://github.com/octokit/octokit.rb) gem
- A GitHub access token set as an environment variable.

## Installation

1. Ensure you have Ruby installed on your system.
2. Install the Octokit gem:
   ```sh
   gem install octokit
   ```
3. Download the prfetch.rb script to your desired directory.

## Usage
Set the necessary environment variables and run the script as follows:

```sh
# When using a Pull Request URL
./prfetch.rb https://github.com/owner/repo/pull/PR_NUMBER

# When using just a Pull Request ID
GITHUB_ACCESS_TOKEN=your_token GH_OWNER_REPO=owner/repo ./prfetch.rb PR_NUMBER
```

## Environment Variables

* `GH_OWNER_REPO`: Set this to 'owner/repo' format when using a PR ID.
* `GITHUB_ACCESS_TOKEN`: Your GitHub access token. This is required for accessing GitHub's API. You can view your GitHub token by running `gh auth token`.

## Error Handling
The script provides informative error messages for common issues such as:

Missing Octokit gem.
Missing or invalid GitHub access token.
Missing or incorrect GH_OWNER_REPO environment variable for PR ID input.

## Contributions
Feel free to fork, modify, and submit pull requests to this script. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
