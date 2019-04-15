git fetch origin
git merge origin/master

pip3 install -r requirements.txt


python3 manage.py migrate 
python3 manage.py collectstatic --no-input 
python3 manage.py compress --force

supervisorctl restart djangoblog
service nginx restart