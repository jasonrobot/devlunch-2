/**
 * common.js - useful, handy functions go in here, for reimporting elsewhere
 * is this a good architechtural decision? Lets find out!
 */

/**
 * @param {*} event
 * @implicit-param event.target.name must corresppond to property name in this.state
 *                 and is taken from the name="" of the target element
 */
function genericFormChangeHandler(event) {
    const key = event.target.name,
          value = event.target.value;

    this.setState(
      {[key]: value}
    );
  }


  const NOT_COMING = 0
  const JOINING = 1
  const VOTING = 2

export {genericFormChangeHandler};