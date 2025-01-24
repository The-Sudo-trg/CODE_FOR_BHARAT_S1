pragma solidity ^0.8.0;

contract InsurancePolicy {

    struct Policy {
        uint256 policyId;
        address policyHolder;
        uint256 premiumAmount;
        uint256 coverageAmount;
        bool isClaimed;
    }

    uint256 public policyCount;
    mapping(uint256 => Policy) public policies;

    event PolicyCreated(uint256 policyId, address indexed policyHolder, uint256 premiumAmount, uint256 coverageAmount);
    event ClaimFiled(uint256 policyId, address indexed policyHolder);
    event ClaimApproved(uint256 policyId);

    // Create a new insurance policy
    function createPolicy(uint256 premiumAmount, uint256 coverageAmount) external payable {
        require(msg.value == premiumAmount, "Premium amount not matched");

        policyCount++;
        policies[policyCount] = Policy({
            policyId: policyCount,
            policyHolder: msg.sender,
            premiumAmount: premiumAmount,
            coverageAmount: coverageAmount,
            isClaimed: false
        });

        emit PolicyCreated(policyCount, msg.sender, premiumAmount, coverageAmount);
    }

    // File an insurance claim
    function fileClaim(uint256 policyId) external {
        Policy storage policy = policies[policyId];
        require(policy.policyHolder == msg.sender, "Not your policy");
        require(!policy.isClaimed, "Claim already filed");

        policy.isClaimed = true;

        emit ClaimFiled(policyId, msg.sender);
    }

    // Approve the claim and release funds
    function approveClaim(uint256 policyId) external {
        Policy storage policy = policies[policyId];
        require(policy.isClaimed, "Claim not filed");

        payable(policy.policyHolder).transfer(policy.coverageAmount);

        emit ClaimApproved(policyId);
    }
}
