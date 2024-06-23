import { useLoaderData, Link } from "react-router-dom";
import { useEffect, useState } from "react";
import { Helmet } from "react-helmet-async";
import styles from './GamesIndex.module.scss'
import { Game, getGames, GamesIndexResponse } from "../../services/GamesService";
import GamesTable from "../../components/GamesTable";

export async function loadGames() : Promise<GamesIndexResponse> {
  const data = await getGames();
  return data;  
}

const GamesIndex = () => {

  const { games } = useLoaderData() as GamesIndexResponse;
  const [showInactive, setShowInactive] = useState<boolean>(true);
  const [searchTerm, setSearchTerm] = useState<string>("All");
  const [filteredOpenGames, setFilteredOpenGames] = useState<Game[]>(games.open);
  const [filteredDevGames, setFilteredDevGames] = useState<Game[]>(games.dev);


  const onFilterChange = (event : React.SyntheticEvent) => {
    setSearchTerm((event.target as HTMLOptionElement).value);
  };
  
  const onShowInactiveChange = (event : React.SyntheticEvent) => {
    setShowInactive((event.target as HTMLInputElement).checked);
  };
  
  useEffect(() => {
    const categoryFilter = (game : Game, categoryValue : string) => {
      return categoryValue === 'All' ? true : game.category === categoryValue;
    }
    const activeFilter = (game : Game, showInactiveValue : boolean) => {
      return showInactiveValue ? true : game.is_active;
    }
        
    setFilteredOpenGames(games.open.filter( (g: Game) => 
       categoryFilter(g, searchTerm) && activeFilter(g, showInactive) ));

    setFilteredDevGames(games.dev.filter( (g: Game) => 
       categoryFilter(g, searchTerm) && activeFilter(g, showInactive) ));
       
  }, [searchTerm, showInactive]);

  return (
    <>
      <Helmet>
        <title>Games - AresCentral</title>
      </Helmet>
      <h1>Games</h1> 
      
      <a href="#open">Open</a> | <a href="#dev">In Development</a> | <Link to="/games/archive">Past</Link>
      <a id="open" />
      <h2>Open Games</h2>
      
      <div className={styles['game-filters']}>
        <select
          id='category-select'
          name='category-select'
          className={styles['category-select']}
          value={searchTerm}
          onChange={onFilterChange}
        >
          <option value="All">All</option>
          <option value="Comic">Comic</option>
          <option value="Fantasy">Fantasy</option>
          <option value="Historical">Historical</option>
          <option value="Modern">Modern</option>
          <option value="Sci-Fi">Sci-Fi</option>
          <option value="Social">Social</option>
          <option value="Supernatural">Supernatural</option>
          <option value="Other">Other</option>
        </select>
      
        <div>
         <input type="checkbox" 
          name="showInactive"
          onChange={onShowInactiveChange} 
          checked={showInactive} 
         /> Show Inactive
        </div>

        <div>
          <i className="fas fa-heartbeat"></i> = Recently Updated
        </div>
      </div>
          
      <GamesTable games={filteredOpenGames} />
      
      
      <a id="dev" />
      <h2>Games in Development</h2>
      
      <GamesTable games={filteredDevGames} />
      
      <a id="past" />
      <h2>Past Games</h2>
      
      <p>View closed games in <Link to="/games/archive">the archive</Link>.</p>
    </>
  );
};

export default GamesIndex;