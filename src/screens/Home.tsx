import type { FC } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from 'styled-components';

export const HomeScreen: FC = () => {
	const navigate = useNavigate();

	const onConnect = () => {
		navigate('/wallet');
	};

	return (
		<Container className="container-block bgsize">
			<ConnectButton onClick={onConnect}>
				<ConnectImg src="img/connect_wallet_button.png" />
			</ConnectButton>
			<IntroImg src="img/connect_wallet_txt.png" />
		</Container>
	);
};

export default HomeScreen;

const Container = styled.div`
	background-image: url('img/connect_wallet_bg.jpg');
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	align-content: flex-end;
`;

const ConnectButton = styled.a`
	width: 100%;
	cursor: pointer;
`;

const ConnectImg = styled.img`
	width: 40%;
	height: auto;
	aspect-ratio: 159 / 71;
	max-width: 759px;
	max-height: 355px;
	margin: 0% auto 0px;
	display: block;
`;

const IntroImg = styled.img`
	width: 40%;
	height: auto;
	aspect-ratio: 151 / 19;
	padding: 0 30% 5vw;
`;
