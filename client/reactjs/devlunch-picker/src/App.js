import React, { Component } from 'react';
import './App.css';

/**
 * data-deps:
 * - app-state
 */
class Header extends Component {
  render() {
    return (
      <div className="header">
        {/* should say different things depending on app state */}
        <div className="header_label">Time left: </div>
        <Timer />
      </div>
    );
  }
}

/**
 * data-deps:
 * - app-state: time of next state change
 */
class Timer extends Component {
  render() {
    return (
      <div className="timer">
        {/* TODO get data from app state or something */}
        unknown
      </div>
    )
  }
}

/**
 * data-deps:
 * - callbacks to update state
 */
class SignupForm extends Component {
  constructor(props) {
    super(props)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleChange = this.handleChange.bind(this)  
  }

  handleSubmit(event) {
    event.preventDefault()
    alert("submitting as " + this.state.action + "\n" +
          "with data {" + this.state.nickname + ": " + this.state.pick + "}")
    /*TODO: something like:
     * POST(session, data)
     */
  }

  handleChange(event) {
    let key = event.target.name,
        value = event.target.value;
    
    this.setState(
      {[key]: value}
    );
  }

  setAction(which) {
    this.setState({action: which})
  }

  render() {
    return (
      <form className="signup-form" onSubmit={this.handleSubmit}>
        <input name="nickname" className="signup-form_nickname" placeholder="nickname"
         onChange={this.handleChange} />
        <input name="pick" className="signup-form_pick" placeholder="pick"
         onChange={this.handleChange}/>
        <button type="submit" className="signup-form_minus" onClick={() => this.setAction(NOT_COMING)}>-</button>
        <button type="submit" className="signup-form_tilde" onClick={() => this.setAction(JOINING)}>~</button>
        <button type="submit" className="signup-form_plus" onClick={() => this.setAction(VOTING)}>+</button>        
      </form>
    )
  }
}

/**
 * data-deps:
 * - value to display
 */
class UserList extends Component {
  render() {
    return (
      <div className="user-list">
        {this.props.what}
        <ul>
          {this.props.users.map( (user) => {
            return <li className="user-list_user">{user.nickname}</li>
          })}
        </ul>
      </div>
    )
  }
}

const NOT_COMING = 0
const JOINING = 1
const VOTING = 2

function makeUser(nickname, status) {
  return {
    nickname: nickname,
    status: status
  }
}

function getSampleUsers() {
  return [
    makeUser("foo", VOTING),
    makeUser("bar", VOTING),
    makeUser("baz", VOTING),
    makeUser("usr", JOINING),
    makeUser("etc", JOINING),
    makeUser("tmp", JOINING),
    makeUser("home", NOT_COMING),
    makeUser("root", NOT_COMING)
  ];
}

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      currentUser: "tester",
      allUsers: getSampleUsers()
    }
  }

  render() {
    let voting = this.state.allUsers.filter( (user) => {
      return user.status === VOTING
    });
    let joining = this.state.allUsers.filter( (user) => {
      return user.status === JOINING
    });
    return (
      <div className="App">
        <Header />
        <SignupForm />
        <UserList what="voting" users={voting} />
        <UserList what="joining" users={joining} />
      </div>
    );
  }
}

export default App;
