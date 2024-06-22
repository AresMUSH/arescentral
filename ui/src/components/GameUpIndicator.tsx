import Label from "./Label"

interface GameUpIndicatorProps {
  status: string;
}

export const GameUpIndicator = ( { status }: GameUpIndicatorProps ) => {
  
  return (
     <Label status={status === 'Up' ? 'game-up' : 'game-down'}>{status}</Label>
  );
}

export default GameUpIndicator;


    


