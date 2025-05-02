import { Controller } from '@hotwired/stimulus';
import isValidHttpUrl from '../lib/URLUtils';

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
      this.showWarning('Please enter a valid URL.');
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
        row.innerHTML = `
          <td>${link.name}</td>
          <td>${link.url}</td>
          <td>
            <button type="button" class="btn btn-sm btn-danger" data-action="ticket-links#deleteLink" data-index="${index}">
              Delete
            </button>
          </td>
        `;
        this.tbodyTarget.appendChild(row);
      });
    }
  }

  // Update the hidden input field with the current links
  updateField() {
    this.dataFieldTarget.value = JSON.stringify(this.links);
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
