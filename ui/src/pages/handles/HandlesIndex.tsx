import { useLoaderData, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import handlePlaceholder from '../../assets/ares-gs.png'
import styles from './HandlesIndex.module.scss'
import { Handle, getHandles, HandlesIndexResponse } from "../../services/HandlesService";

export async function loadHandles() : Promise<HandlesIndexResponse> {
  const data = await getHandles();
  return data;
}

const HandlesIndex = () => {

  const { handles } = useLoaderData() as HandlesIndexResponse;
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0'.split('');
  
  const onScrollClick = (event : React.SyntheticEvent) => {
    const id = (event.target as HTMLButtonElement).id.replace('button-', '');
    const sectionId = `handles-${id}`;
    const section = document.getElementById(sectionId);
    if (section) {
      section.scrollIntoView();
    }      
  };
  
  const filterHandles = (letter : string) => {
    if (letter === '0') {
      return handles.filter((h : Handle) => /^[0-9].+/.test(h.name));
    }
    return handles.filter((h : Handle) => h.name.toUpperCase().startsWith(letter));
  };
  
  return (
    <>
      <Helmet>
        <title>Player Handles - AresCentral</title>
      </Helmet>
      <h1>Handles</h1> 

    {
        alphabet.map(letter => {
          const buttonId = `button-${letter}`;
          return <button id={buttonId} key={buttonId} onClick={onScrollClick} className={styles['handle-nav']}>{letter}</button>;
        })

    }
    {
        alphabet.map(letter => {
          const sectionId = `handles-${letter}`;
          
          return  <div key={sectionId}>
            <hr/>
            <h2 id={sectionId}>{letter}</h2>
            <div className={styles['handles-gallery']}>
            {       
                filterHandles(letter).map( (h : Handle) => 
        
                 <Link to={`/handle/${h.name}`} className={styles['handle-name']} key={h.id}>
                   <div className={styles['handle-box']}> 
                     <img className={styles['handle-profile']} src={h.image_url || handlePlaceholder } />              
                     {h.name}             
                   </div>
                 </Link>  
              )
            }
          </div>
          </div>
        })
    }
        
    </>
  );
};

export default HandlesIndex;