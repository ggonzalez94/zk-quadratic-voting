# Quadratic voting using zk proofs

This repo shows a [quadratic voting](https://www.economist.com/interactive/2021/12/18/quadratic-voting) application that leverages zk proofs to keep users votes secret, while making sure each one is counted in the final result.
The votes of each user are kept secret to everyone, except a trusted ballot manager that is in charge of counting the votes, but cannot censor or modify user's choices.  
Here's an architecture diagram of the solution:

![architecture](./images/architecture.png)

## Circuits

### Cast Ballot (user circuit)

-   Enforces Quadratic Voting rules
-   Outputs a comittment for the user to share publicly and can be verified

### Count Votes(manager circuit)

-   Enforces that all committed votes are counted
-   Outputs the vote total for each candidate

## DSLs

The application is written in the following DSLs to show the differences and nuances of each:

-   [Noir](https://github.com/noir-lang/noir) :white_check_mark:
-   [Zokrates](https://github.com/Zokrates/ZoKrates): :white_check_mark:

The repo is based on [ZK HACK III Workshop - Noir](https://www.youtube.com/watch?v=5CziMfChveY)

### Comparison

**Noir**  
**+** Inputs are private by default.  
**+** Noir uses PLONK by default, which doesn't require a trusted setup per application.  
**+** Error messages from the compiler are very intuitive.  
**+** Hash functions and type casting were easy to use.  
**-** No support for 2D arrays(but that's on the way)  
**-** No logging functionality. That makes debugging more challenging, you have to use asserts to see where your circuit is failing.

**Zokrates**  
**+** Python-like syntax is easier to grasp.
**+** Better documentation(since it is more mature).
**+** Support for 2D arrays and logging.  
**-** Passing parameters via CLI becomes very cumbersome and support for JSON is very limited.  
**-** Calling functions with no return values from main is not allowed, which hinders modularity.  
**-** Cannot split function arguments in multiple lines.  
**-** Errors from the compiler are somewhat cryptic.  
**-** I found hash functions harder to use.

**Conclusion:** Both Zokrates and Noir are high level languages(or as high level as we can ask for zk DSLs at this point), that allow regular developers without moon math knowledge to get started. Even though I initially liked the syntax of Zokrates more, I ended up having a much better experience with Noir. It was overall easier to use, error messages were much clearer and using nargo was very easy.

## Usage

### Noir

1. First build both circuits using nargo build

    ```sh
    $ nargo build
    ```

2. To simulate votes from Alice and Bob you need to run the prover twice. There are 2 examples in the Prover.toml that you can use and comment/uncomment each input as needed. Inside the cast-ballot folder, run the following command for each voter:
    ```sh
    $ nargo prove p
    ```
3. If you want to verify the proof in the console:
    ```sh
    $ nargo verify p
    ```
4. Now go to the count-votes folder to interact with the manager circuit. You need to fill the Prover.toml file with the commitments generated in step 2 and fill the other values if you modified the votes or secrets.
    ```sh
    $ nargo prove p
    ```
5. If you want to verify the proof in the console:
    ```sh
    $ nargo verify p
    ```

---

### Zokrates

1. First build both circuits using zokrates compile(inside each folder).

    ```sh
    $ zokrates compile -i root.zok
    ```

2. Run the setup. Remember that Zokrates uses by default the Groth16 scheme, which requires a setup per application. If you want to perform a trusted setup using multi-party computation follow [this](https://zokrates.github.io/toolbox/trusted_setup.html).
    ```
    $ zokrates setup
    ```
3. To simulate votes from Alice and Bob you need to run the prover twice. There are 2 examples in the input.txt that you can use to copy/paste each input as needed. Unlike Nor there is no easy way to specify the parameters, so you have to pass them as arguments.  
   Inside the cast-ballot folder, run the following command for each voter:

    ```sh
    $ zokrates compute-witness -a <your arguments>
    $ zokrates generate-proof
    ```

4. If you want to verify the proof in the console:

    ```sh
    $ zokrates verify
    ```

5. Now go to the count-votes folder to interact with the manager circuit. In the input.txt file you will see an example you can use. You will need to pass the commitments from step 3 and fill the other values if you modified the votes or secrets.
    ```sh
    $ zokrates compute-witness -a <your arguments>
    $ zokrates generate-proof
    ```
6. If you want to verify the proof in the console:

    ```sh
    $ zokrates verify
    ```
