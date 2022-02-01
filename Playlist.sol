// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Playlist {
    struct Song {
        string name;
        bool favourite;
    }
    Song[] public songs;

    function create(string calldata _name) external {
        songs.push(Song({
            name: _name,
            favourite: false
        }));
    }
    function updateSongName(uint _index, string calldata _name) external {
        songs[_index].name = _name;
    }

    function updateSongStatus(uint _index) external {
        songs[_index].favourite = !songs[_index].favourite;
    }

    function getSong(uint _index) view external returns(string memory, bool) {
        Song memory song = songs[_index];
        return(song.name, song.favourite);
    }
}