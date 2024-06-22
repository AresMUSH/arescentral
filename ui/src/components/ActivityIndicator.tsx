//import styles from "./ActivityIndicator.module.scss";

interface ActivityIndicatorProps {
  rating: number
}

export const ActivityIndicator = ({ rating }: ActivityIndicatorProps) => {
    
  
  if (rating > 0 && rating <= 1) {
   return <i className="fa fa-star-half"></i>;
  }

  let ratings = [];  
  for (let i = 0; i <= rating - 1; i++) {
    ratings.push( <i className="fa fa-star" key={`star${i}`}></i> );
  }
  
  if (rating - Math.floor(rating) > 0) {
   ratings.push( <i className="fa fa-star-half" key='starhalf'></i> );
  }
     
  return (
    <>
     { ratings }
    </>
  );
}

export default ActivityIndicator;