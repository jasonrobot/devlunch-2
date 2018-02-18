import React, { Component } from 'react';
import {genericFormChangeHandler} from './common.js';

class LoginForm extends Component {
    constructor(props) {
      super(props)

      this.state = {}

      this.handleChange = genericFormChangeHandler.bind(this)
      this.handleSubmit = this.handleSubmit.bind(this)
    }

    handleSubmit(event) {
      event.preventDefault()
      //dunno what to do here

      let data = new FormData();
      data.append('username', this.state.username)

      const reqData = {
        method: 'POST',
        headers: {},
        body: data
      };

      //be good handle errors
      let fetchSuccess = response => {
        return response.text()
      }
      let fetchError = error => {console.error('fetch error')}
      let decodeSuccess = data => {
        alert("holy-o-fuck, we've got data boys!\n" + data)
        // TODO do stuff with session id here
        // this.props.returnSessionId(data);
        this.state.sessionId = data;
      }
      let decodeError = error => {console.error('decode error')}
      let response = (
        fetch('http://localhost:4567/login', reqData)
        .then(fetchSuccess, fetchError)
        .then(decodeSuccess.bind(this), decodeError)
      );
      // alert('logging in as user: ' + this.state.username)
    }

    render() {
      if (!this.state.sessionId) {
        return(
          <div className="login-form">
            <form onSubmit={this.handleSubmit}>
              <input name="username" placeholder="user id" onChange={this.handleChange}/>
              <button>Login</button>
            </form>
          </div>
        )
      }
      else {
        return(
          <div className="login-info">
            <div>You are logged in as {this.state.sessionId}</div>
          </div>
        )
      }

    }
  }

export default LoginForm;