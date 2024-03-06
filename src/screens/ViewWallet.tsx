import type { FC } from 'react';
import { useState } from 'react';
import CharacterCard from 'components/CharacterCard';
import styled from 'styled-components';

export const ViewWallet: FC = () => {
	const [selectVisible, setSelectVisible] = useState(false);

	return (
		<>
			<Container className="container-block bgsize">
				<ConnectImg
					src="./img/view_opponent_wallet_button.png"
					onClick={() => setSelectVisible(true)}
				/>
			</Container>
			{selectVisible && (
				<CharacterBox className="container-block bgsize">
					<Character>
						<CharacterCard id="char1" visualSrc="/img/bubble_gunner.png" />
						<CharacterCard id="char2" visualSrc="/img/meta_whelp.png" />
						<CharacterCard id="char3" visualSrc="/img/double_agent.png" />
						<CharacterCard id="char4" visualSrc="/img/morak_galahad.png" />
						<CharacterCard id="char5" visualSrc="/img/dragon_speaker.png" />
						<CharacterText className="character-self-text bg-common bgsize" />
						<CharacterText className="character-self-text bg-uncommon bgsize" />
						<CharacterText className="character-self-text bg-uncommon bgsize" />
						<CharacterText className="character-self-text bg-rare bgsize" />
						<CharacterText className="character-self-text bg-common bgsize" />
					</Character>
				</CharacterBox>
			)}
		</>
	);
};

export default ViewWallet;

const Container = styled.div`
	background-image: url('./img/connect_wallet_bg.jpg');
	display: flex;
	flex-wrap: wrap;
	justify-items: center;
	align-content: center;
	cursor: pointer;
`;

const ConnectImg = styled.img`
	width: 40%;
	height: auto;
	aspect-ratio: 159 / 71;
	max-width: 759px;
	max-height: 355px;
	margin: 18.55% auto 0px;
	display: block;
`;

const CharacterBox = styled.div`
	display: flex;
	position: absolute;
	top: 0vw;
	left: 0vw;
	background-color: rgba(0, 0, 0, 0.75);
	flex-wrap: wrap;
	justify-content: center;
	align-content: flex-end;
`;

const Character = styled.div`
	width: 97%;
	height: fit-content;
	padding-bottom: 6.6vw;

	.character-self-text {
		width: 20%;
		min-height: 8vw;
		text-align: center;
		float: left;

		&.bg-size {
			background-position: center bottom;
		}

		&.bg-common {
			background-image: url('./img/common.png');
			background-size: 81.5% auto;
			-webkit-background-size: 81.5% auto;
		}

		&.bg-uncommon {
			background-image: url('./img/uncommon.png');
			background-size: 100% auto;
			-webkit-background-size: 100% auto;
		}

		&.bg-rare {
			background-image: url('./img/rare.png');
			background-size: 56% auto;
			-webkit-background-size: 56% auto;
		}
	}
`;

const CharacterText = styled.div``;
