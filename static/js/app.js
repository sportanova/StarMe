var App = React.createClass({
  getInitialState: function() {
    return {
      myStarred: 'highlightMenu'
    }
  },
  highlight: function(className) {
    if(className === 'myStarred') {
      this.setState({myStarred: 'highlightMenu', toStar: '', 'myRepos': '', iStarred: ''})
    }
    else if(className === 'toStar') {
      this.setState({myStarred: '', toStar: 'highlightMenu', 'myRepos': '', iStarred: ''})
    }
    else if(className === 'myRepos') {
      this.setState({myStarred: '', toStar: '', 'myRepos': 'highlightMenu', iStarred: ''})
    }
    else if(className === 'iStarred') {
      this.setState({myStarred: '', toStar: '', 'myRepos': '', iStarred: 'highlightMenu'})
    }
  },
  render: function() {
    var cx = React.addons.classSet;
    var menuClasses = cx({
      'pure-menu ': true,
      'pure-menu-open': true,
      'pure-menu-horizontal': true
    });

    return (
      <div>
        <div className={menuClasses}>
          <ul>
            <li><a className={this.state.myStarred} onClick={this.highlight.bind(this, 'myStarred')} href="#">My Starred Repos</a></li>
            <li><a className={this.state.toStar} onClick={this.highlight.bind(this, 'toStar')} href="#">My Repos To Star</a></li>
            <li><a className={this.state.myRepos} onClick={this.highlight.bind(this, 'myRepos')} href="#">All My Repos</a></li>
            <li><a className={this.state.iStarred} onClick={this.highlight.bind(this, 'iStarred')} href="#">Repos I Starred </a></li>
          </ul>
        </div>
        <Repos repoType='selected' username={this.props.username}/>
        <Repos repoType='public' username={this.props.username}/>
      </div>
    );
  }
});

function StarMe() {
}

StarMe.prototype.init = function(domNode, attrs) {
  this.react = React.render(<App username={attrs.username}/>, domNode);
  return this.react;
};

StarMe.prototype.setState = function(attrs) {
  this.react.setState(attrs);
};