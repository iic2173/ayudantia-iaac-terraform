# Parse command line arguments
for ARGUMENT in "$@"
do
  KEY=$(echo $ARGUMENT | cut -f1 -d=)

  KEY_LENGTH=${#KEY}
  VALUE="${ARGUMENT:$KEY_LENGTH+1}"

  export "$KEY"="$VALUE"
done

# Check arguments provided
if [ -z "$ENV" ]; then
  echo "No ENV argument supplied"
  echo "Usage: ./scripts/provision.sh ENV=<ENVIRONMENT>"
  exit 1
fi

if test -f "config/$ENV.env"; then
  echo "Loading environment from ./config/$ENV.env"
  . config/$ENV.env
else
  echo "./config/$ENV.env does not exist."
  exit 1
fi
