import type { FC } from 'react';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import GetCardScreen from 'screens/GetCard';
import HomeScreen from 'screens/Home';
import ViewWalletScreen from 'screens/ViewWallet';

export const router = createBrowserRouter([
	{
		path: '/wallet',
		element: <ViewWalletScreen />,
	},
	{
		path: '/collect',
		element: <GetCardScreen />,
	},
	{
		path: '/',
		element: <HomeScreen />,
	},
]);

export const App: FC = () => {
	return <RouterProvider router={router} />;
};

export default App;
