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

    //form data to submit
    this.state = 
    { formParams:
        { "nickname": ""
        , "pick": ""
        }
    }
    
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleChange = this.handleChange.bind(this)
  }

  handleSubmit(event) {
    event.preventDefault()
    alert("submitting as " + this.state.action + "with data\n" +
          "this.state.nickname: " + this.state.nickname + "\n" +
          "this.state.pick: " + this.state.pick)
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
        {
          Object.keys(this.state.formParams).map( key => {
            return (
              <input name={key} className={'signup-form_' + key} placeholder={key} onChange={this.handleChange} />
            )
          })
        }
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

class User {
  constructor (name, id, status, nickname, pick) {
    this.name = name
    this.id = id
    this.status = status || NOT_COMING
    this.nickname = nickname || name
    this.pick = pick || ""
  }
}

function getSampleUsers() {
  return [
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
      currentUser: "tester",
      allUsers: getSampleUsers()
    }
  }

  componentWillMount() {
    //fetch all our data here!
    //{"name":"tester","id":4,"status":"out","nickname":"tester","pick":""}
    // var xmlHttp = new XMLHttpRequest();
    // xmlHttp.open( "GET", "localhost:4567/users", true ); // false for synchronous request
    // xmlHttp.send( null );
    // console.log(xmlHttp.responseText)
    
    console.log("fetching")
    fetch('http://localhost:4567/users', {
      method: 'GET',
    }).then( response => { //success
      return response.text()
    }, error => { //failure
      console.log("there was an error")
      console.log(error)
    }).then( function(text) {
      console.log('should have something here')
      console.log(text)
      console.log(typeof text)
      console.log(text === '')
    })
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
