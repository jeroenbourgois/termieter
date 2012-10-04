if [[ `uname` == 'Darwin' ]]; then

  # OSX 

  alias mongo-backup='mongodump --host=127.0.0.1:27017 --out=~/.backups/backups/mongodb/dag-`date +%u`'
  alias mongo-start='mongod run --config /usr/local/Cellar/mongodb/2.0.4-x86_64/mongod.conf --rest'

# else

  # LINUX
  

fi
