import type { FC } from 'react';
import styled from 'styled-components';

interface Props {
	id: string;
	selected?: boolean;
	visualSrc: string;
}

export const CharacterCard: FC<Props> = ({ visualSrc, selected }) => {
	const classes = selected ? 'character-self-box showt' : 'character-self-box';

	return (
		<Container className={classes}>
			<VisualImg src={visualSrc} />
		</Container>
	);
};

export default CharacterCard;

const Container = styled.div`
	width: 20%;
	height: auto;
	aspect-ratio: 380 / 565;
	vertical-align: middle;
	margin-bottom: -1vw;
	float: left;

	&:after,
	&:before {
		width: 19%;
		height: auto;
		content: '';
		background-repeat: no-repeat;
		background-size: contain;
		position: absolute;
		mix-blend-mode: normal;
		aspect-ratio: 1/1;
	}

	&:after {
		opacity: 0;
		background-image: url('/img/target1_upper_layer.png');
		margin: 5.5vw 0 0 -19vw;
		z-index: 2;
	}

	&:before {
		opacity: 0;
		background-image: url('./img/target2_lower_layer.png');
		margin: 5.5vw 0 0 0.38vw;
		z-index: 3;
	}

	&.showt::after {
		animation-name: checkgo1;
		animation-iteration-count: 1;
		animation-duration: 0.5s;
		animation-fill-mode: forwards;
	}

	&.showt::before {
		animation-name: checkgo2;
		animation-iteration-count: 1;
		animation-duration: 0.3s;
		animation-delay: 0.5s;
		animation-fill-mode: forwards;
	}

	img {
		width: 100%;
	}
`;

const Text = styled.span`
	color: white;
	padding: 10px;
`;

const VisualImg = styled.img``;
