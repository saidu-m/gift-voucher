Gift Voucher Smart Contract

The Gift Voucher contract is a simple and beginner-friendly smart contract built on the "Stacks blockchain using Clarity". It allows users to mint personal vouchers, send them to others, and burn them when they are no longer needed.

This contract is great for:
- Learning Clarity smart contract development
- Understanding token logic (without full fungible token complexity)
- Hackathon / Streak submissions
- Open-source contribution portfolio building


Features

| Function | Description |
|--------|-------------|
| `mint` | Allows the caller to create new vouchers. |
| `transfer` | Sends vouchers from your account to another user. |
| `burn` | Allows the caller to destroy some of their vouchers. |
| `get-balance` | View the voucher balance of any user. |
| `get-total-supply` | Shows the total number of vouchers in circulation. |


 Contract Logic

- Each user can hold a balance of vouchers.
- Total supply updates automatically when vouchers are minted or burned.
- Only the wallet owner can burn or transfer their vouchers.
- No admin or privileged account → fully decentralized.


Requirements

- "Clarinet" installed  
  ```sh
  npm install -g @hirosystems/clarinet
