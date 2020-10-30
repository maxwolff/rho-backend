# rho-backend

Reads rho contract logs, put them in an agent, and provides and endpoint for accessing them.

* `client.ex`: interface for reading logs from an ethereum node
* `logs.ex`: job loop to fill an array of logs and map of pending swaps
* `endpont.ex`: serve pending swaps over http 

## Run
`MIX_ENV=prod NETWORK=kovan iex -S mix`

## Deploy
`gcloud app deploy`
