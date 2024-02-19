const { writeFileSync } = require('fs');

module.exports = {
	solidity: "0.8.23",
	networks: {
		// ... network configurations 
	},
	paths: {
		sources: "./contracts",
		artifacts: "./artifacts"
	},
	remappings: {
		"@openzeppelin/contracts": "node_modules/@openzeppelin/contracts"
	}
};

task("extract-abi", "Extracts ABI from contract")
	.setAction(async () => {
		const artifacts = await hre.artifacts.readArtifact("Looting");
		writeFileSync('./src/utils/abi.json', JSON.stringify(artifacts.abi, null, 2))
	});
