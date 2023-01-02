use dep::std;
global CANDIDATE_COUNT = 10;

fn main(
    token_budget: pub u32, // budget of max votes to enforce
    votes: [u32;CANDIDATE_COUNT], // ballot of user representing it's votes for each candidate
    secret: Field // for shielding the commitment from brute-force attacks
) -> pub Field{
    check_within_budget(token_budget, votes); 
    calculate_ballot_commitment(votes, secret)
}

//The proof that we will generate ensures the user respected the token_budget
//because we have an explicit constrain here
fn check_within_budget(token_budget: u32, votes: [u32;CANDIDATE_COUNT]) {
    let mut sum: u32 = 0;
    for i in 0..CANDIDATE_COUNT {
        sum = sum + votes[i] * votes[i];
    }
    constrain sum <= token_budget;
}

// Hashes the content of a ballot using pedersen and returns that value
fn calculate_ballot_commitment(votes: [u32; CANDIDATE_COUNT], secret: Field) -> Field{
    let mut input = [0; CANDIDATE_COUNT + 1];
    input[0] = secret;
    for i in 0..CANDIDATE_COUNT {
        input[i+1] = votes[i] as Field;
    }
    let commitment = std::hash::pedersen(input)[0];
    commitment
}