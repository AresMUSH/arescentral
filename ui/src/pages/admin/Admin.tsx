import { useLoaderData, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { getStats, StatsResponse } from "../../services/AdminService";
//import styles from './Admin.module.scss'

export async function loadStats() : Promise<StatsResponse>{
  const data = await getStats();  
  return data;
}

const Stats = () => {

  const { stats } = useLoaderData() as StatsResponse;
  
  return (
    <>
      <Helmet>
        <title>Admin Dashboard - AresCentral</title>
      </Helmet>
      <h1>Admin Dashboard</h1> 
      
    <Link to="/admin/games">[ Games Admin ]</Link>
    <Link to="/admin/plugin/create">[ Create Plugin ]</Link>
      
    <p><b>Total Games</b>: {stats.total_games}</p>
    <p><b>Public Open Games</b>: {stats.open_games}</p>
    <p><b>Public Dev Games</b>: {stats.dev_games}</p>
    <p><b>Private Games</b>: {stats.private_games}</p>
    <p><b>Closed Games</b>: {stats.closed_games}</p>
    <p><b>Total Handles</b>: {stats.total_handles}</p>         
    
    </>
  );
};

export default Stats;