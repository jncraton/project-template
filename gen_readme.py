import subprocess

github = str(subprocess.check_output(['git', 'remote', 'get-url', 'origin']))

name = github.split('/')[-1].split('.')[0]
user = github.split('/')[-2]

netlify = "https://%s-%s.netlify.com" % (user, name)

readme = """# %s

The output of this project is available here:

%s

If you would like to build this yourself locally, you can do so using the following commands:

    pip3 install -r requirements.txt
    make

This will generate the output document `index.html` that can be viewed locally.
""" % (name, netlify)

print(readme)
