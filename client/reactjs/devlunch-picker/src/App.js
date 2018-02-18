import React, { Component } from 'react';
import './App.css';
import Header from './Header.js';
// import * as SignupForm from './SignupForm.js';
import Timer from './Timer.js';

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

/**
 * data-deps:
 * - callbacks to update state
 */
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

/**
 * data-deps:
 * - value to display
 */
class UserList extends Component {
  render() {
    // If there are no users, dont make a list
    if (this.props.users.length === 0) {
      return (
        <div className="user-list_empty">
        </div>
      )
    }

    const what = this.props.what.charAt(0).toUpperCase() + this.props.what.slice(1)
    return (
      <div className="user-list">
        <div className="user-list_header">
          {what}
        </div>
        <ul className="user-list_list">
          {this.props.users.map( (user) => {
            return <li key={user.nickname} className="user-list_user">{user.nickname}</li>
          })}
        </ul>
      </div>
    )
  }
}

const NOT_COMING = 0
const JOINING = 1
const VOTING = 2

class User {
  constructor (name, nickname, id, status = NOT_COMING, pick = "") {
    this.name = name
    this.nickname = nickname || name
    this.id = id
    this.status = status
    this.pick = pick
  }

  static statusFromString (status) {
    if (status === 'voting') {
      return VOTING
    }
    else if (status === 'joining') {
      return JOINING
    }
    else {
      return NOT_COMING
    }
  }
}

function getFakeUsers() {
  return [
    new User("USING FAKE USERS", 0, VOTING, "", ""),
    new User("foo", 0, VOTING, "", ""),
    new User("bar", 0, VOTING, "", ""),
    new User("baz", 0, VOTING, "", ""),
    new User("bin", 0, JOINING, "", ""),
    new User("etc", 0, JOINING, "", ""),
    new User("dev", 0, JOINING, "", ""),
    new User("home", 0, NOT_COMING, "", ""),
    new User("root", 0, NOT_COMING, "", ""),
  ];
}

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      sessionId: undefined,
      currentUser: "tester",
      allUsers: [],
    }
  }

  // TODO FIXME all this data needs to come in in the right format
  static getRealUsers() {

    let options = {
      method: 'GET',
    }

    // success of request, now get the data out
    let fetchSuccess = response => {
      return response.json()
    }

    // failure of request
    let fetchError = error => {
      console.log("there was an error in requesting data from the server. Is it running, and is your cross-origin shit sorted?")
      console.log(error)
    }

    //success of from json
    let decodeSuccess = data => {
      return data.map(user => {
        Object.setPrototypeOf(user, User.prototype)
        user.status = User.statusFromString(user.status)
        return user
      })
    }

    let decodeError = error => {
      console.error("You've probably got some invalid JSON coming back from the server. Write better unit test, nerd.")
      return getFakeUsers();
    }

    // let response = fetch('http://localhost:4567/users', options);
    // let result = response.then(fetchSuccess, fetchError);
    // return result.then(decodeSuccess, decodeError)
    return (
      fetch('http://localhost:4567/users', options)
      .then(fetchSuccess, fetchError)
      .then(decodeSuccess, decodeError)
    );
  }

  componentDidMount() {
    //fetch all our data here!
    App.getRealUsers().then(users => {
      this.setState({
        allUsers: users
      })
    })
  }

  render() {
    const voting = this.state.allUsers.filter( (user) => {
      return user.status === VOTING
    });
    const joining = this.state.allUsers.filter( (user) => {
      return user.status === JOINING
    });
    return (
      <div className="App">
        <LoginForm />
        <Header />
        <SignupForm />
        <UserList what="voting" users={voting} />
        <UserList what="joining" users={joining} />
      </div>
    );
  }
}

export default App;
