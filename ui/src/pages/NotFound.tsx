import { Helmet } from "react-helmet-async";

const NotFound = () => {
  return (
    <>
      <Helmet>
        <title>Not Found - AresCentral</title>
      </Helmet>
      
      <h1>Not Found</h1>
      <p>Sorry, the page you are looking for is not here.</p>
      
      <p>If the you have found a broken link, please report the issue at <a href="https://aresmush.com/feedback" target="_blank" rel="noreferrer noopener">aresmush.com</a>.</p>
      
    </> );
};

export default NotFound;