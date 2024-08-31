import requests
import json
#use github your token
GITHUB_TOKEN = 'github_token'
GITHUB_API_URL = 'https://api.github.com/search/issues'
headers = {
    'Authorization': f'token {GITHUB_TOKEN}',
    'Accept': 'application/vnd.github.v3+json',
}
# Define the search query
#query = 'maven security is:issue'
# Define the search query
query = 'make security is:issue'

#Set up the parameters for the API request
params = {
    'q': query,
    'per_page': 100,  # Maximum number of results per page
}

# Make the API request
response = requests.get(GITHUB_API_URL, headers=headers, params=params)
response_data = response.json()

# Check if the response is valid
if response.status_code == 200:
    issues = response_data.get('items', [])
    with open('make_security_issues.txt', 'w') as file:
        for issue in issues:
            file.write(issue['html_url'] + '\n')
    print(f"Successfully saved {len(issues)} issue links to 'make_security_issues.txt'")
else:
    print(f"Failed to fetch issues: {response_data}")
    
    #Handle pagination if there are more than 100 results
total_count = response_data.get('total_count', 0)
if total_count > 100:
    for page in range(2, (total_count // 100) + 2):
        params['page'] = page
        response = requests.get(GITHUB_API_URL, headers=headers, params=params)
        response_data = response.json()
        issues = response_data.get('items', [])
        with open('make_security_issues.txt', 'a') as file:
            for issue in issues:
                file.write(issue['html_url'] + '\n')
        print(f"Successfully appended {len(issues)} issue links from page {page} to 'cmake_security_issues.txt'")
