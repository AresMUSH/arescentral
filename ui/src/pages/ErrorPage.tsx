import { useRouteError } from "react-router-dom";
import aresLogo from '../assets/logo.png'
import styles from './ErrorPage.module.scss'

export default function ErrorPage() {
  interface ErrorData {
    statusText: string | null;
    message: string | null;
  }
  
  const error = useRouteError() as ErrorData;
  console.error(error || "Unknown error.");

  return (
    <div className={styles['error-page']}>
      <h1>Oops!</h1>
      <img src={aresLogo} className={styles['error-logo']} />
      
      <p>Sorry, an unexpected error has occurred. Please try again.</p>
      <p>If the problem persists, please report what you were doing (and any error details below) at <a href="https://aresmush.com/feedback" target="_blank" rel="noreferrer noopener">aresmush.com</a>.</p>
      {
       error ? <p className={styles["error-details"]}><i>{error.statusText || error.message}</i></p> : '' 
      }
    </div>
  );
}