error() {
  echo " !     $*" >&2
  exit 1
}

status() {
  echo "-----> $*"
}

protip() {
  echo
  echo "PRO TIP: $*" | indent
  echo "See https://devcenter.heroku.com/articles/nodejs-support" | indent
  echo
}

# sed -l basically makes sed replace and buffer through stdin to stdout
# so you get updates while the command runs and dont wait for the end
# e.g. npm install | indent
indent() {
  c='s/^/       /'
  case $(uname) in
    Darwin) sed -l "$c";; # mac/bsd sed: -l buffers on line boundaries
    *)      sed -u "$c";; # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

cat_npm_debug_log() {
  test -f $build_dir/npm-debug.log && cat $build_dir/npm-debug.log
}


install_db2_odbc() {
		DB2_DIR="$1"
		if [ ! -d "$DB2_DIR" ]; then
		    mkdir -p "$DB2_DIR"
			DB2_DSDRIVER_URL="http://9.38.14.143/projects/mdbs/cff/v10.5fp3_linuxx64_dsdriver.tar.gz"
			status "downloading DB2 ODBC driver..."
			curl ${DB2_DSDRIVER_URL} -s -o ${DB2_DIR}/db2cli.tar.gz
			tar xzf ${DB2_DIR}/db2cli.tar.gz -C ${DB2_DIR}
			tar xzf ${DB2_DIR}/dsdriver/odbc_cli_driver/linuxamd64/ibm_data_server_driver_for_odbc_cli.tar.gz -C ${DB2_DIR}
			rm -f   $DB2_DIR/db2cli.tar.gz
			rm -rf  $DB2_DIR/dsdriver
		fi
		export IBM_DB_HOME="$DB2_DIR/clidriver"
}
