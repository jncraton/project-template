import subprocess

github = str(subprocess.check_output(['git', 'remote', 'get-url', 'origin']))

name = github.split('/')[-1].split('.')[0]
user = github.split('/')[-2]

netlify = "https://%s-%s.netlify.com" % (user, name)

readme = """# %s

The output of this project is available here:

%s
""" % (name, netlify)

print(readme)
