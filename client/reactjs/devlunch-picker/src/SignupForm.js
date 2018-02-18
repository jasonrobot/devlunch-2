import React, { Component } from 'react';
import {genericFormChangeHandler} from './common.js';

class SignupForm extends Component {
    constructor(props) {
      super(props)

      //form data to submit
      this.state = {
        formParams:
          {
            "nickname": "",
            "pick": "",
          }
      }

      this.handleSubmit = this.handleSubmit.bind(this)
      this.handleChange = genericFormChangeHandler.bind(this)
    }

    handleSubmit(event) {
      event.preventDefault()
      alert(
        "submitting as " + this.state.action + " with data\n" +
        "this.state.nickname: " + this.state.nickname + "\n" +
        "this.state.pick: " + this.state.pick
      )
      /*TODO: something like:
       * POST(session, data)
       */
    }

    // handleChange(event) {
    //   let key = event.target.name,
    //       value = event.target.value;
    //   this.setState(
    //     {[key]: value}
    //   );
    // }

    setAction(which) {
      this.setState({action: which})
    }

    render() {
      return (
        <div className="signup-form">
          <form className="signup-form_form" onSubmit={this.handleSubmit}>
            {
              Object.keys(this.state.formParams).map( key => {
                return (
                  <input name={key} key={key} className={'signup-form_form_' + key} placeholder={key} onChange={this.handleChange} />
                )
              })
            }
            <div className="signup-form_buttons">
              <button type="submit" className="signup-form_buttons_minus" onClick={() => this.setAction(NOT_COMING)}>-</button>
              <button type="submit" className="signup-form_buttons_tilde" onClick={() => this.setAction(JOINING)}>~</button>
              <button type="submit" className="signup-form_buttons_plus" onClick={() => this.setAction(VOTING)}>+</button>
            </div>
          </form>
        </div>
      )
    }
  } /* SignupForm */

  export default SignupForm;