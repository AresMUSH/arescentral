import { useEffect, useState } from "react";
import { useLoaderData } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import styles from './PluginsIndex.module.scss'
import { Plugin, getPlugins, PluginsIndexResponse } from "../../services/ContribsService";
import PluginInfo from "../../components/PluginInfo";
import { useAuth } from '../../contexts/AuthContext';

export async function loadPlugins() : Promise<PluginsIndexResponse> {
  const data = await getPlugins();
  return data;
}

const PluginsIndex = () => {

  const { plugins } = useLoaderData() as PluginsIndexResponse;
  const [searchTerm, setSearchTerm] = useState<string>("All");
  const [filteredPlugins, setFilteredPlugins] = useState<Plugin[]>(plugins);
  const { user } = useAuth();
  
  const onFilterChange = (event : React.SyntheticEvent) => {
    setSearchTerm((event.target as HTMLOptionElement).value);
  };
  
  useEffect(() => {
    if (searchTerm === 'All') {
      setFilteredPlugins(plugins);
    } else {
      setFilteredPlugins(plugins.filter( (p : Plugin) => p.category === searchTerm));
    }
  }, [searchTerm]);
    
  return (
    <>
      <Helmet>
        <title>Plugins - AresCentral</title>
      </Helmet>
      <h1>Plugins</h1> 
      
      <select
        id='plugin-select'
        name='plugin-select'
        value={searchTerm}
        onChange={onFilterChange}
      >
        <option value="All">All</option>
        <option value="Skills">Skills</option>
        <option value="System">System</option>
        <option value="RP">RP</option>
        <option value="Community">Community</option>
        <option value="Other">Other</option>
      </select>
      

      <p><i className="fas fa-globe"></i> = Web Portal Support Included | <i className="fas fa-laptop-code"></i> = Custom Code Required</p>
      
      <div className={styles['plugins-gallery']}>
        {       
          filteredPlugins.map( (p : Plugin) => 
        
           <PluginInfo key={p.key} plugin={p} user={user} />
          )
        }
      </div>
    </>
  );
};

export default PluginsIndex;