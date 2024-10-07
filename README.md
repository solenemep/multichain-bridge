Multichain bridge implementing Across protocol

### Test

```shell
$ make test-all
```

### Deploy

```shell
$ make deploy-all
```

### Back-end integration

Before interacting with contract, back-end must collect data.

Let's say depositor wants to bridge `tokenAmount` of `tokenAddress` from `originChainId` to `destinationChainId`.

Back-end will first call our AcrossRelayer contract.
The method `getInputAmount` with input param the total `tokenAmount` will return 2 outputs :

- the `acrossAmount` that is `tokenAmount - feeAmount`
- the `feeAmount` which AccrosRelayer will send to fee receiver

Then, let's fetch `suggested-fees` from API :
`https://app.across.to/api/suggested-fees?token=${tokenAddress}&originChainId=${originChainId}&destinationChainId=${destinationChainId}&amount=${acrossAmount}`

This will provide the 2 following parameters to call `brigdeNative` and `bridgeERC20` :

- `totalRelayFee`

### Notes

SpokePool on Polygon does not have enabled deposit routes for native tokens at the moment.
