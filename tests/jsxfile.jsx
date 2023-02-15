export default [ 'nothing' ];

const RED = 'red';
const BURGUNDY = 'rgba(255, 101, 120, 0.5)';

export function abc() {
  return (
    <div className="text-blue-500" style="color: red;">
      {expression()}
      <Fragment>
        {`hi ${there}`}
      </Fragment>
      <>
        <Another>
          <Test
            prop1="abc"
            prop2={{ def: GHI.JKL }}
            poop={false}
            //commentedProp={true}
          >Strings in strings in strings
          </Test>
        </Another>
      </>
    </div>
  );
};
