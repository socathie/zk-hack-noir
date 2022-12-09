use dep::std;

global CANDIDATE_COUNT = 10;
global VOTER_COUNT = 2;

fn main(
    commitments: pub [Field; VOTER_COUNT], 
    all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT], 
    secrets: [Field; VOTER_COUNT]
    ) -> pub [u32; CANDIDATE_COUNT] {
    check_commitments(commitments, secrets, all_votes);
    sum_votes(all_votes)
}

fn sum_votes (all_votes: [u32; VOTER_COUNT*CANDIDATE_COUNT])
 -> [u32; CANDIDATE_COUNT] {
    let mut vote_counts = [0; CANDIDATE_COUNT];
    for i in 0..VOTER_COUNT {
        for j in 0..CANDIDATE_COUNT {
            vote_counts[j] = vote_counts[j] + all_votes[i * CANDIDATE_COUNT + j];
        }
    }
    vote_counts
}

fn check_commitments (
    commitments: [Field; VOTER_COUNT], 
    secret: [Field; VOTER_COUNT], 
    all_votes: [u32; VOTER_COUNT*CANDIDATE_COUNT]
    ) {
    let mut transcript = [0; CANDIDATE_COUNT + 1];
    for i in 0..VOTER_COUNT {
        transcript[0] = secret[i];
        for j in 0..CANDIDATE_COUNT {
            transcript[j + 1] = all_votes[i * CANDIDATE_COUNT + j] as Field;
        }
        constrain commitments[i] == std::hash::pedersen(transcript)[0];
    }

}