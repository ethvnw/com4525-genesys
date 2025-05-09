import { Controller } from '@hotwired/stimulus';
import isValidHttpUrl from '../lib/URLUtils';

/* This is a Stimulus controller for handling the addition and deletion of ticket links for plans.
To use, include the following elements:
  data-controller="ticket-links" - Calls the controller
  data-ticket-links-target="name" - The input field for the link name
  data-ticket-links-target="url" - The input field for the link URL
  data-ticket-links-target="dataField" - The hidden input field that stores the links as JSON
  data-ticket-links-target="tbody" - The table body element where the links are displayed
  data-ticket-links-target="table" - The table element that contains the links
  data-ticket-links-target="warning" - The span element that displays warning messages
*/

export default class extends Controller {
  static get targets() {
    return ['name', 'url', 'dataField', 'tbody', 'table', 'warning'];
  }

  connect() {
    this.links = [];
    this.loadFromField(); // Load existing links if they exist.
    this.render();
  }

  // Add a new link to the list
  addLink() {
    const name = this.nameTarget.value.trim();
    const url = this.urlTarget.value.trim();

    this.showWarning(''); // Clear previous warnings

    if (!name || !url) return;

    // Check if the link already exists (by name or URL)
    if (this.links.some((link) => link.name === name)) {
      this.showWarning('A ticket link with this name already exists.');
      return;
    } if (this.links.some((link) => link.url === url)) {
      this.showWarning('A ticket link with this URL already exists.');
      return;
    } if (!isValidHttpUrl(url)) {
      // isValidHttpUrl is a utility function that checks if the URL starts with http:// or https://
      this.showWarning('Please enter a valid URL (beginning with http:// or https://).');
      return;
    } if (this.links.length >= 10) {
      this.showWarning('You can only add up to 10 ticket links.');
      return;
    }

    this.links.push({ name, url });
    this.updateField();
    this.render();

    this.nameTarget.value = '';
    this.urlTarget.value = '';
  }

  // Remove a link from the list
  deleteLink(event) {
    const { index } = event.currentTarget.dataset;
    this.links.splice(index, 1);
    this.updateField();
    this.render();
  }

  render() {
    this.tbodyTarget.innerHTML = '';

    if (this.links.length === 0) {
      this.tableTarget.classList.add('d-none');
    } else {
      this.tableTarget.classList.remove('d-none');

      this.links.forEach((link, index) => {
        const row = document.createElement('tr');

        const nameCell = document.createElement('td');
        nameCell.textContent = link.name;

        const urlCell = document.createElement('td');
        urlCell.textContent = link.url;

        const deleteButtonCell = document.createElement('td');
        const button = document.createElement('button');
        button.type = 'button';
        button.classList.add('btn', 'btn-sm', 'btn-danger', 'd-inline-flex', 'align-items-center', 'gap-1');
        button.setAttribute('data-action', 'ticket-links#confirmAndDelete');
        button.setAttribute('data-confirm', 'Are you sure you want to delete this ticket link?');
        button.setAttribute('data-index', index);
        button.setAttribute('aria-label', `Delete Ticket Link with name ${link.name} and URL ${link.url}`);

        const icon = document.createElement('i');
        icon.classList.add('bi', 'bi-trash');

        button.appendChild(icon);
        button.appendChild(document.createTextNode('Delete'));

        deleteButtonCell.appendChild(button);

        row.appendChild(nameCell);
        row.appendChild(urlCell);
        row.appendChild(deleteButtonCell);

        this.tbodyTarget.appendChild(row);
      });
    }
  }

  // Update the hidden input field with the current links
  updateField() {
    this.dataFieldTarget.value = JSON.stringify(this.links);
  }

  confirmAndDelete(event) {
    this.deleteLink(event);
  }

  // For the edit page, reload existing links from the hidden input field
  loadFromField() {
    try {
      const existing = this.dataFieldTarget.value;
      if (existing) this.links = JSON.parse(existing);
    } catch (e) {
      this.links = [];
    }
  }

  // Show a warning message
  showWarning(message) {
    this.warningTarget.textContent = message;
  }
}
