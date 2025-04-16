import { Helmet } from "react-helmet-async";
//import styles from './ThemesIndex.module.css'

const ThemesIndex = () => {
  return (
    <>
      <Helmet>
        <title>Themes - AresCentral</title>
      </Helmet>
      <h1>Community Themes</h1>

      <p>These are community-contributed themes you can install in your web portal. Themes will include colors, custom styles and/or images. Click on the theme name to view the files on GitHub, including previews.</p>

      <p>To install a theme, use <code>theme/install &lt;github url&gt;</code> with an admin character in-game. For example: <code>theme/install https://github.com/AresMUSH/ares-dark-theme</code>.</p>


      <div className="alert alert-info">
      <b>Note!</b>  Installing a theme will overwrite your current web portal theme. The files will be backed up to the aresmush/theme_archive folder if you need to get them back. Community themes are not officially supported (unless otherwise specified).
      </div>

      <h2>Available Themes</h2>
      <ul>
      <li><a href="https://github.com/girlcalledblu/ares-basicblu-theme" target="_blank" rel="noopener">Basic Bluk</a> by Blu</li> - Sleek dark theme with nice fonts and colors.
      </ul>
      
      <p>See the <a href="https://aresmush.com/tutorials/code/contribs/" target="_blank" rel="noopener">AresMUSH submission guidelines</a> if you want to contribute your own themes.</p>
      
    </>
  );
}

export default ThemesIndex;