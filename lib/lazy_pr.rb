require "lazy_pr/version"

module LazyPr
	class CreatePr

		def initialize
			@head_branch = ARGV[0]
			@pull_request_title = ARGV[1]
			check_params
		end

		def login_user
			if access_token.nil?
				login_using_credentials
			else
				login_using_access_token
			end
		end

		def create_pull_request
			begin
				@client.create_pull_request(repo, @head_branch, base, pull_request_title)
				puts "Successfully created PR...!"
			rescue Octokit::UnprocessableEntity => e
				puts e.errors[0][:message]
			rescue
				puts "Failed to  create PR. Please ensure you have required authorization."
			end
		end

		private

		def check_params
			if @head_branch.nil?
				puts "Pass the branch name you want your changes pulled into (ex: lazypr master)"
				exit(false)
			end
		end
		
		def access_token
			ENV["github_personal_access_token"]
		end

		def login_using_credentials
			puts "Can't find the access token...!"
			puts "Github Username"
			username = STDIN.gets.chomp
			puts "Github Password"
			password = STDIN.noecho(&:gets).chomp
			puts "\nLogging In..."
			begin
				@client = Octokit::Client.new login: username, password: password
				user = @client.user
				user.login
			rescue
				puts "Login failed. Try again."
				exit(false)
			end
		end

		def login_using_access_token
			begin
				@client = Octokit::Client.new(access_token: access_token)
				user = @client.user
				user.login
			rescue
				puts "Login failed using access token. Please check your access token."
				exit(false)
			end
		end

		def repo
			remote_url = `git config remote.origin.url`
			if remote_url.nil? || remote_url.empty?
				puts "Can't find remote url. Make sure you have configured the remote repo."
				exit(false)
			end
			return parse_url remote_url 
		end

		def base
			begin
				base_branch = `git rev-parse --abbrev-ref HEAD`
				return base_branch.partition("\n").first
			rescue
				puts "Make sure you have atleast one commit."
				exit(false)
			end
		end

		def pull_request_title
			return @pull_request_title unless @pull_request_title.nil?
			return base
		end

		def parse_url remote_url
			if remote_url.include?("https")
				return remote_url.partition(".com/").last.partition(".git").first
			else
				return remote_url.partition(":").last.partition(".git").first
			end
		end
	end
end
