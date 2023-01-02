# Quadratic Voting using zk proofs [WIP]

This repo shows a quadratic voting application that leverages zk proofs to keep users votes secret, while making sure each one is counted in the final result.

## Circuits

### Cast Ballot (user circuit)

-   Enforces Quadratic Voting rules
-   Outputs a comittment for the user to share publicly and can be verified

### Count Votes(manager circuit)

-   Enforces that all committed votes are counted
-   Outputs the vote total for each candidate

## DSLs

The application is written in the following DSLs to show the differences:

-   [Noir](https://github.com/noir-lang/noir) :white_check_mark:
-   [Zokrates](https://github.com/Zokrates/ZoKrates): TODO

The repo is based on [ZK HACK III Workshop - Noir](https://www.youtube.com/watch?v=5CziMfChveY)
