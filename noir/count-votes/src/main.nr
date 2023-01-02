use dep::std;
global CANDIDATE_COUNT = 3;
global VOTER_COUNT = 2;

fn main(commitments: [Field; VOTER_COUNT], secrets: [Field; VOTER_COUNT], all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT]) -> pub [u32; CANDIDATE_COUNT] {
    check_commitments(commitments, secrets, all_votes);
    let result = sum_votes(all_votes);
    result
}

fn sum_votes(all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT]) -> [u32; CANDIDATE_COUNT] {
    let mut result = [0; CANDIDATE_COUNT];
    for i in 0..VOTER_COUNT {
        for j in 0..CANDIDATE_COUNT {
            result[j] = result[j] + all_votes[CANDIDATE_COUNT * i + j];
        }
    };
    result
}

fn check_commitments(
    commitments: [Field; VOTER_COUNT], 
    secrets: [Field; VOTER_COUNT], 
    all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT]
) {     
    let mut input = [0; CANDIDATE_COUNT + 1];
    for i in 0..VOTER_COUNT {
        //get secret for voter i
        input[0] = secrets[i]; 
        for j in 0..CANDIDATE_COUNT {
            input[j+1] = all_votes[CANDIDATE_COUNT * i + j] as Field;
        }
        // calculate commitment for voter i
        let commitment = std::hash::pedersen(input)[0];
        // verify commitment against input
        constrain commitment == commitments[i];
    };
}