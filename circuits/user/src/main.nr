use dep::std;

global CANDIDATE_COUNT = 10;
global VOTER_COUNT = 2;

fn main(
    token_budget: pub u32, 
    votes: [u32; CANDIDATE_COUNT], 
    secret: Field
    ) -> pub Field {
    check_within_budget(token_budget, votes);
    calculate_ballot_commitment(votes, secret)
}

fn check_within_budget (
    token_budget: u32,
    votes: [u32; CANDIDATE_COUNT]
    ) {
    let mut tokens_spent: u32 = 0;
    for i in 0..CANDIDATE_COUNT {
        tokens_spent = tokens_spent + votes[i]*votes[i];
    }

    constrain token_budget >= tokens_spent;
}

fn calculate_ballot_commitment (votes: [u32; CANDIDATE_COUNT], secret: Field )
 -> Field{
    let mut transcript = [0; CANDIDATE_COUNT + 1];
    transcript[0] = secret;
    for i in 0..CANDIDATE_COUNT {
        transcript[i + 1] = votes[i] as Field;
    }
    std::hash::pedersen(transcript)[0]
}