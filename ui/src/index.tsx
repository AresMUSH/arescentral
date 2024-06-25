import React from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { createRoot } from "react-dom/client";
import App from "./App";
import Home from "./pages/Home";
import Terms from "./pages/Terms";
import ErrorPage from "./pages/ErrorPage";
import Login from "./pages/login/Login";
import Register from "./pages/login/Register";
import ForgotPassword from "./pages/login/ForgotPassword";
import ChangePassword from "./pages/login/ChangePassword";
import SSOLogin from "./pages/login/SSOLogin";
import GamesIndex, { loadGames } from "./pages/games/GamesIndex";
import GameDetail, { loadGame } from "./pages/games/GameDetail";
import GamesArchive, { loadClosedGames } from "./pages/games/GamesArchive";
import GamesAdmin, { loadGamesAdmin } from "./pages/admin/GamesAdmin";
import Admin, { loadStats } from "./pages/admin/Admin";
import HandlesIndex, { loadHandles } from "./pages/handles/HandlesIndex";
import HandleDetail, { loadHandle } from "./pages/handles/HandleDetail";
import Friends from "./pages/handles/Friends";
import LinkedCharacters from "./pages/handles/LinkedCharacters";
import Preferences from "./pages/handles/Preferences";
import Account from "./pages/handles/Account";
import CreatePlugin from "./pages/admin/CreatePlugin";
import EditPlugin, { loadPlugin } from "./pages/admin/EditPlugin";
import EditGame from "./pages/admin/EditGame";
import PluginsIndex, { loadPlugins } from "./pages/contribs/PluginsIndex";
import ThemesIndex from "./pages/contribs/ThemesIndex";
import NotFound from "./pages/NotFound";
import {AuthProvider} from "./contexts/AuthContext";

const container = document.getElementById("root");

const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
    errorElement: <ErrorPage />,
    children: [
      {
        path: "/",
        element: <Home />
      },
      {
        path: "/login",
        element: <Login />
      },
      {
        path: "/register",
        element: <Register />
      },  
      {
        path: "/forgot-password",
        element: <ForgotPassword />
      },
      {
        path: "/change-password",
        element: <ChangePassword />
      },
      {
        path: "/terms",
        element: <Terms />
      },
      {
        path: "/games",
        element: <GamesIndex />,
        loader: loadGames
      },
      {
        path: "/game/:gameId",
        element: <GameDetail />,
        loader: loadGame
      },
      {
        path: "/games/archive",
        element: <GamesArchive />,
        loader: loadClosedGames
      },
      {
        path: "/admin/games",
        element: <GamesAdmin />,
        loader: loadGamesAdmin
      },
      {
        path: "/admin/game/:gameId/edit",
        element: <EditGame />,
        loader: loadGame
      },
      {
        path: "/admin/plugin/create",
        element: <CreatePlugin />
      },
      {
        path: "/admin/plugin/:pluginId/edit",
        element: <EditPlugin />,
        loader: loadPlugin
      },
      {
        path: "/admin",
        element: <Admin />,
        loader: loadStats
      },
      {
        path: "/handles",
        element: <HandlesIndex />,
        loader: loadHandles
      },
      {
        path: "/handle/:handleId",
        element: <HandleDetail />,
        loader: loadHandle
      },
      {
        path: "/account",
        element: <Account />
      },
      {
        path: "/preferences",
        element: <Preferences />
      },
      {
        path: "/friends",
        element: <Friends />
      },
      {
        path: "/linked-chars",
        element: <LinkedCharacters />
      },
      {
        path: "/plugins",
        element: <PluginsIndex />,
        loader: loadPlugins
      },
      {
        path: "/themes",
        element: <ThemesIndex />
      },
      {
        path: "/error",
        element: <ErrorPage />
      },
      {
        path: "/sso",
        element: <SSOLogin />
      },
      {
        path: "*",
        element: <NotFound />,
      },
    ]
  },
  
]);

const root = createRoot(container!);
root.render(
    <React.StrictMode>
      <AuthProvider>
        <RouterProvider router={router} />
      </AuthProvider>
  </React.StrictMode>
);