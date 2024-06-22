import { Link } from "react-router-dom";
import { LoginSession } from "../services/SessionStorage";
import { Plugin } from "../services/ContribsService";
import styles from "./PluginInfo.module.scss";
import Markdown from 'react-markdown'
import Label from "./Label"

interface PluginInfoProps {
  plugin: Plugin,
  user: LoginSession | null | undefined
}

export const PluginInfo = ({ plugin, user }: PluginInfoProps) => {
  
  return (
    <div className={styles['plugin-card']}>
      <a href={plugin.url} className={styles['plugin-title']} target="_blank" rel="noopener noreferrer">{plugin.name}</a>

      <div className={styles['plugin-info']}>

        <Label status={plugin.category.toLowerCase()} className={styles['category-label']}>{plugin.category}</Label>

        <div className={styles['plugin-icons']}>
            { plugin.web_portal ? <i className="fas fa-globe" title="Web Portal Supported"></i> : <></> }
            { plugin.custom_code ? <i className="fas fa-laptop-code" title="Custom Code Required"></i> : <></> }
        </div>         
            
        <div>
              {plugin.installs} installs 
        </div>
                           
      </div>
      
      <div>
            by <Link to={`/handle/${plugin.author_name}`}>@{plugin.author_name}</Link>
      </div>

      
      <Markdown children={plugin.description} />
      
         
         { user && user.is_admin ? <Link to={`/admin/plugin/${plugin.id}/edit`}>[Edit]</Link> : '' }
    
      
    </div>
  );
}

export default PluginInfo;