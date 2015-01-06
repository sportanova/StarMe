var Repo = React.createClass({
  getInitialState: function() {
    return {
      repo: this.props.data
    }
  },
  toggleRepos: function(e) {
  },
  toggleCheckbox: function() {
    var isChecked = !this.props.isChecked;
    this.props.toggleCheckboxCB(isChecked);
  },
  render: function() {
    return (
      <div>
        <span>{this.props.data.name}</span>
          <label>
            <input onChange={this.toggleCheckbox.bind(this)} defaultChecked={this.props.isChecked} checked={this.props.isChecked} type="checkbox"/>
          </label>
      </div>
    );
  }
});