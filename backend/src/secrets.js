const {
  SecretsManagerClient,
  GetSecretValueCommand,
} = require("@aws-sdk/client-secrets-manager");

const client = new SecretsManagerClient({
  region: process.env.AWS_REGION || "eu-west-1",
});

async function getDatabaseSecret() {
  const secretArn = process.env.DB_SECRET_ARN;

  if (!secretArn) {
    throw new Error("DB_SECRET_ARN environment variable is missing");
  }

  const command = new GetSecretValueCommand({
    SecretId: secretArn,
  });

  const response = await client.send(command);

  if (!response.SecretString) {
    throw new Error("SecretString is empty");
  }

  return JSON.parse(response.SecretString);
}

module.exports = {
  getDatabaseSecret,
};