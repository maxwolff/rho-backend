# Rho

`MIX_ENV=prod NETWORK=kovan iex -S mix`

* `client.ex`: interface for reading logs from an ethereum node
* `logs.ex`: job loop to fill an array of logs and map of pending swaps
* `endpont.ex`: serve pending swaps over http 
