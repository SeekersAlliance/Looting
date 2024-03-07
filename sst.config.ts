import type { SSTConfig } from 'sst';
import type { StackContext } from 'sst/constructs';
import { StaticSite } from 'sst/constructs';

export const Site = ({ stack }: StackContext) => {
	const site = new StaticSite(stack, 'site', {
		path: 'metacraft',
	});

	stack.addOutputs({
		url: site.url || 'localhost',
	});
};

export default {
	config() {
		return {
			name: 'seeker-alliance',
			region: 'ap-south-1',
		};
	},
	stacks(app) {
		app.stack(Site);
	},
} satisfies SSTConfig;
