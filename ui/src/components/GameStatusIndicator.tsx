import Label from "./Label"

interface GameStatusIndicatorProps {
  status: string
}

export const GameStatusIndicator = ( { status }: GameStatusIndicatorProps ) => {
  
  var statusClass;
    switch(status) {
      case 'Beta':
        statusClass = 'limited';
        break;
      case 'Open':
        statusClass = 'open';
        break;
      case 'In Development':
      case 'Alpha':
        statusClass = 'dev';
        break;
      default:
        statusClass = '';
        break;
    }

  return (
     <Label status={statusClass}>{status === "In Development" ? "In Dev" : status}</Label>
  );
}

export default GameStatusIndicator;


    


