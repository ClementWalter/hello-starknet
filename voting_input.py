import json

from starkware.crypto.signature.signature import (
    pedersen_hash,
    private_to_stark_key,
    sign,
)

# Set an identifier that will represent what we're voting for.
# This will appear in the user's signature to distinguish
# between different polls.
POLL_ID = 10018


# Generate key pairs.
# See "Safety note" below.
priv_keys = [123456 * i + 654321 for i in range(10)]
pub_keys = [private_to_stark_key(priv_key) for priv_key in priv_keys]


# Generate 3 votes of voters 3, 5, and 8.
votes = []
for (voter_id, vote) in [(3, 0), (5, 1), (8, 0)]:
    r, s = sign(msg_hash=pedersen_hash(POLL_ID, vote), priv_key=priv_keys[voter_id])
    votes.append(
        {
            "voter_id": voter_id,
            "vote": vote,
            "r": hex(r),
            "s": hex(s),
        }
    )

# Write the data (public keys and votes) to a JSON file.
input_data = {
    "public_keys": list(map(hex, pub_keys)),
    "votes": votes,
}

with open("voting_input.json", "w") as f:
    json.dump(input_data, f, indent=4)
    f.write("\n")

input_data["public_keys"][3] = "0x0"
input_data["public_keys"][5] = "0x0"
input_data["public_keys"][8] = "0x0"

# Generate a "yes" vote for voter 6.
voter_id = 6
vote = 1
r, s = sign(msg_hash=pedersen_hash(POLL_ID, vote), priv_key=priv_keys[voter_id])
input_data["votes"] = [
    {
        "voter_id": voter_id,
        "vote": vote,
        "r": hex(r),
        "s": hex(s),
    }
]

with open("voting_input2.json", "w") as f:
    json.dump(input_data, f, indent=4)
    f.write("\n")
